import SwiftUI

class ExerciseManager: ObservableObject {
    @Published var exercises = [Exercise]()

    func fetchExcercises() {
        guard let urlExerciseList = URL(string: "https://wger.de/api/v2/exerciseinfo/?format=json") else { return }
        let task = URLSession.shared.dataTask(with: urlExerciseList) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  error == nil else {
                return
            }
            do {
                let list = try JSONDecoder().decode(ExerciseList.self, from: data)
                print("Fetching name")
                DispatchQueue.main.async {
                    self.exercises = list.results
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }

    func fetchExcerciseImages(exerciseID: Int) {
        guard let urlExerciseImage = URL(string: "https://wger.de/api/v2/exerciseimage/\(exerciseID)/thumbnails/") else { return }
        let task = URLSession.shared.dataTask(with: urlExerciseImage) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  error == nil else {
                assertionFailure()
                return
            }
            do {
                let list = try JSONDecoder().decode([ExecrciseImage].self, from: data)
                print("Fetching")
                guard let exerciseIndex = self.exercises.firstIndex(where: { $0.id == exerciseID }) else {
                    print("no index found")
                    return

                }
                DispatchQueue.main.async {
                    print("cellIndex")
                    self.exercises[exerciseIndex].images = list
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
