import MacroExpress

// As with all "Macro*", this tries to replicate the Node.js/Express.js APIs
// for Swift.
//
// This implements a TodoMVC example backend.

let PORT = process.getenv("PORT", defaultValue: 8042)

// A global used in the model layer, yeah, lame. In a real app this wouldn't be
// part of the model.
let ourAPI = "http://localhost:\(PORT)/todomvc/"

let app = express()

app.use(logger("dev"), bodyParser.json(), cors(allowOrigin: "*"))
   .use(serveStatic(__dirname() + "/public"))

// Workaround a bug in spec-tool (see `addAcceptJSON` for details)
app.get("/todomvc/*", addAcceptJSON())


// MARK: - Storage

let todos = VolatileStoreCollection<Todo>()

// prefill
todos.objects[42] =
  Todo(id: 42, title: "Buy Beer",     completed: true, order: 1)
todos.objects[43] =
  Todo(id: 43, title: "Buy Mo' Beer", completed: false, order: 2)


// MARK: - Routes & Handlers

app.del("/todomvc/todos/:id") { req, res in
  guard let id = req.params[int: "id"] else { return res.sendStatus(400) }
  todos.delete(id: id)
  res.sendStatus(200)
}

app.del("/todomvc") { req, res in
  todos.deleteAll()
  res.json([]) // everything deleted, respond with an empty array
}

app.patch("/todomvc/todos/:id") { req, res in
  guard let id = req.params[int: "id"] else { return res.sendStatus(404) }
  guard var todo = todos.get(id: id)   else { return res.sendStatus(404) }
  
  if let t = req.body.title     as? String { todo.title     = t }
  if let t = req.body.completed as? Bool   { todo.completed = t }
  if let t = req.body.order     as? Int    { todo.order     = t }
  todos.update(id: id, value: todo) // value type!
  
  res.json(todo)
}

app.get("/todomvc/todos/:id") { req, res in
  guard let id = req.params[int: "id"] else { return res.sendStatus(404) }
  guard let todo = todos.get(id: id)   else { return res.sendStatus(404) }
  res.json(todo)
}

app.post("/todomvc/*") { req, res in
  guard let t = req.body.title as? String else { return res.sendStatus(400) }
  
  let completed = (req.body.completed as? Bool) ?? false
  let order     = (req.body.order     as? Int)  ?? 0
  
  let pkey = todos.nextKey()
  let newTodo = Todo(id: pkey, title: t, completed: completed, order: order)
  todos.update(id: pkey, value: newTodo) // value type!
  res.status(201).json(newTodo)
}

app.get("/todomvc/*") { req, res in
  if req.accepts("json") != nil {
    res.json(todos.getAll())
  }
  else {
    let clientURL = "http://todobackend.com/client/index.html?\(ourAPI)"
    let testURL   = "http://todobackend.com/specs/index.html?\(ourAPI)"
    
    res.send(
      """
      <html>
        <body>
          <h3>Welcome to the MacroExpress Todo MVC Backend</h3>
          <ul>
            <li><a href="\(clientURL)">Client</a></li>
            <li><a href="\(testURL)"  >Run Test Suite</a></li>
          </ul>
        </body>
      </html>
      """
    )
  }
}

app.listen(PORT) {
  app.log.log("Listening on \(PORT)")
}
