import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    router.get("allTodos") { request -> Future<View> in
        return Todo.query(on: request).all().flatMap(to: View.self) { allTodos in
            let todosContext = TodosContext(todos: allTodos, pageTitle: "This is a title", theBoolean: false)
            return try request.view().render("allTodos", todosContext)
        }
    }
}

struct TodosContext: Content {
    var todos: [Todo]
    var pageTitle: String
    var theBoolean: Bool
}
