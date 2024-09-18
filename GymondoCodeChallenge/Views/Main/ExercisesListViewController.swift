import UIKit
import SwiftUI
import Combine

class ExercisesListViewController: UIViewController {
    @ObservedObject var viewModel: ExercisesViewModel

    var exercises: [Exercise] = []
    var buildDetailsViewModel: ((Int) -> ExerciseDetailsViewModel)!
    var cancellables = Set<AnyCancellable>()
    var collectionView: UICollectionView!

    let backgroundImageView: UIImageView = {
        let bgImageView = UIImageView(frame: .zero)
        bgImageView.image = UIImage(named: "spp")
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        return bgImageView
    }()

    // constructor injection
    init(viewModel: ExercisesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.loadExercises()
        self.viewModel.$state.sink {
            switch $0 {
            case .loaded(exercies: let e):
                self.exercises = e
                self.collectionView.reloadData()
            case .loading:
                print("I am loading")
            default:
                ()
            }
        }.store(in: &cancellables)

        setUpCollectionView()
        setupConstraints()
        setupNavBar()
    }

}

extension ExercisesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exercises.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCardCollectionViewCell.identifier, for: indexPath) as! ExerciseCardCollectionViewCell
        let exercise = exercises[indexPath.row]
        var imageURL: URL?
        if let imageURLString = exercise.images?.first?.image {
            imageURL = URL(string: imageURLString)
        }
        cell.configure(label: exercise.name, url: imageURL)
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isTapped = exercises[indexPath.row]
        self.navigationController?.pushViewController(UIHostingController(rootView: ExerciseDetailsCradView(viewModel: buildDetailsViewModel(isTapped.id))), animated: true)
    }
}

private extension ExercisesListViewController {
    func setupNavBar() {
        self.navigationController?.navigationBar.topItem?.title = "List of Exercises"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 40, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        layout.itemSize = CGSize(width: (view.frame.width-40),
                                 height: (view.frame.height/3)
       )
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ExerciseCardCollectionViewCell.self, forCellWithReuseIdentifier: ExerciseCardCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundView = backgroundImageView
        view.addSubview(collectionView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
