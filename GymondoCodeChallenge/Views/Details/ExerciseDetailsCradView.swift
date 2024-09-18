import SwiftUI
import Kingfisher

struct ExerciseDetailsCradView: View {
    @ObservedObject var viewModel: ExerciseDetailsViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .loaded(exercies: let exercise):
                VStack {
                    // MARK: Exercise title
                    Text(exercise.name)
                        .font(.title.weight(.medium))
                    Spacer()
                    // MARK: Exercise description
                    Text(exercise.description
                        .removeHTML()
                        .removeLine()
                    )
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                    .lineLimit(.none)
                    Spacer()
                    // MARK: Exercise images
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(exercise.images ?? []) { image in
                                KFImage(URL(string: image.image))
                                    .resizable()
                                    .cornerRadius(5)
                                    .frame(width: 100, height: 100)
                                    .padding()
                            }
                        }
                    }
                    Spacer()

                    // MARK: Exercise variations
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {

                            ForEach(exercise.variations, id: \.self) { variation in

                                // important: since not every variation is an existing exercise ID, I have put the exercise ID as the exercise ID itself but not the variation value, so the app doesn't crash in iOS 14
                                // by trying a hard coded ID everything is working as it should be
                                let destination = ExerciseDetailsCradView(viewModel: .init(exerciseService: viewModel.exerciseService, exerciseId: viewModel.exerciseId))
                                // TODO: what's the ID of the Exercise? 
                                NavigationLink(destination: destination) {
                                    VStack {
                                        Image("sn")
                                            .resizable()

                                        Spacer()
                                        Text(String(variation))
                                            .font(.caption2)
                                    }
                                    .foregroundColor(.black)
                                    .frame(width: 80, height: 110, alignment: .leading)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(20)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            default:
                EmptyView()
            }
        }.onAppear {
            viewModel.loadExercise()
        }
    }
}
