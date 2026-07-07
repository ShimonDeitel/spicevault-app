import Foundation

struct SpiceEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var purchaseDate: Date
    var form: String
    var notes: String
    var createdAt: Date

    init(id: UUID = UUID(), name: String = "", purchaseDate: Date = Date(), form: String = "", notes: String = "", createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.purchaseDate = purchaseDate
        self.form = form
        self.notes = notes
        self.createdAt = createdAt
    }
}
