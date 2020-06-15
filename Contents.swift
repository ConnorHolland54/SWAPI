import UIKit

//Create Model
struct Person: Decodable {
    var name: String
    var films: [URL]
}

struct Film: Decodable {
    var title: String
    var opening_crawl: String
    var release_date: String
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    static private let personEndPoint = "people/"
    static private let filmEndPoing = "films/"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        let personId = String(id)
        // 1 - Prepare URL
        guard let baseURL = baseURL else {return completion(nil)}
        let secondURL = baseURL.appendingPathComponent(personEndPoint)
        let finalURL = secondURL.appendingPathComponent(personId)
      
        
        print(finalURL)
        // 2 - Contact Server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
        // 3 - Handle errors
            if let error = error {
                print(error.localizedDescription)
            }
        // 4 - check for data
            guard let data = data else {return}
        // 5 - Decode Person from JSON
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("We had an error deccoding the data - \(error) - \(error.localizedDescription)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
   
        // 2 - Contact the server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
        // 3 - handle any errors
            if let error = error {
                print(error.localizedDescription)
            }
        //4 - Check for data
            guard let data = data else {return completion(nil)}
        //5 - decode film from JSON
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("We had an error decoding the data - \(error) - \(error.localizedDescription)")
                return completion(nil)
            }
        }.resume()
    }
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film)
        }
    }
}

SwapiService.fetchPerson(id: 1) { (person) in
    if let person = person {
        print(person)
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}






