#!/usr/bin/swift sh

import MacroExpress // @Macro-swift


// MARK: - Parse Commandline Arguments & Usage

func usage() {
  let tool = path.basename(process.argv.first ?? "servedocc")
  print(
    """
    Usage: \(tool) <docc archive folder>
    
    Example:
    
      \(tool) SlothCreator.doccarchive
    
    """
  )
}

guard process.argv.count == 2 else {
  usage()
  process.exit(1)
}

let archivePath = process.argv[1]
let indexPath   = archivePath + "/index.html"
let docPath     = archivePath + "/data/documentation"

guard fs.existsSync(archivePath) else {
  print("Specified file does not exist:", archivePath)
  process.exit(2)
}
guard fs.existsSync(indexPath), fs.existsSync(docPath) else {
  print("File does not look like a DocC archive:", archivePath)
  process.exit(3)
}

guard let dataIndex = (try? fs.readdirSync(docPath))?
                              .first(where: { $0.hasSuffix(".json")} )
else {
  print("File does not look like a DocC archive, missing data index:",
        archivePath)
  process.exit(3)
}
let dataIndexPath = docPath + "/" + dataIndex


// MARK: - Serve Individual Files

/// This serves individual, fixed files.
func serveFile(_ path: String) -> Middleware {
  return { req, res, next in
    fs.createReadStream(path)
      .pipe(res)
      .onError { error in
        console.error("Failed to serve \(path):", error)
        res.status(500)
      }
  }
}


// MARK: - Configure and Start the Server

let staticDirs  = [ "css", "data", "downloads", "images", "img",
                    "index", "js", "videos" ]
let staticFiles = [ "favicon.ico", "favicon.svg", "theme-settings.json" ]

let app = express()
app.use(logger("dev"))

// Map all matching requests to this index.html
app.get("/documentation/*",         serveFile(indexPath))
app.get("/tutorials/*",             serveFile(indexPath))
app.get("/data/documentation.json", serveFile(dataIndexPath))

for path in staticDirs { // serve the whole directory ("/*" match)
  app.get("/" + path + "/*", serveStatic(archivePath))
}
for path in staticFiles { // just serve the specific file
  app.get("/" + path, serveStatic(archivePath))
}

// redirects
app.get("/tutorials")     { _, res, _ in res.redirect("/tutorials/")     }
   .get("/documentation") { _, res, _ in res.redirect("/documentation/") }
   .get                   { _, res, _ in res.redirect("/documentation/") }

app.listen(1337) {
  console.log("Server listening on: http://localhost:1337/")
  console.log("DocC Archive:", archivePath)
}
