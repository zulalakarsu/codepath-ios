//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable, Equatable {

    var title: String
    var note: String?
    var dueDate: Date

    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    var isComplete: Bool = false {
        didSet {
            if isComplete {
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    private(set) var completedDate: Date?
    let createdDate: Date = Date()
    let id: String = UUID().uuidString

    static func ==(lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Task + UserDefaults
extension Task {

    private static let tasksKey = "tasks"

    // Save an array of tasks to UserDefaults
    static func save(_ tasks: [Task]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }

    // Retrieve an array of saved tasks from UserDefaults
    static func getTasks() -> [Task] {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            return decoded
        }
        return []
    }

    // Add a new task or update an existing task with the current task
    func save() {
        var tasks = Task.getTasks()

        if let index = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks.remove(at: index)
            tasks.insert(self, at: index)
        } else {
            tasks.append(self)
        }

        Task.save(tasks)
    }
}
