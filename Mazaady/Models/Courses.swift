//
//  Courses.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//

struct CoursesCategory {
    let id: Int
    let name: String
    let courses: [Course]
}
struct Course: Equatable {
    let id: Int
    let category: String
    let title: String
    let duration: String
    let lessons: Int
    let isFree: Bool
    let imageUrl: String
    let author: String
    let authorRole: String
    let authorImageUrl: String
    public static func ==(lhs: Course, rhs: Course) -> Bool {
        return lhs.id == rhs.id
    }
}
