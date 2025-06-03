//
//  MovieDetailViewController.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import UIKit
import Combine

final class MovieDetailViewController: UIViewController {
    
    let viewModel: MovieDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .systemBlue
        label.text = "Description"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupBindings()
        Task { await viewModel.loadPosterImage() }
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(rateLabel)
        contentView.addSubview(languageLabel)
        contentView.addSubview(descriptionTitleLabel)
        contentView.addSubview(overviewLabel)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 580),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            rateLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 4),
            rateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            languageLabel.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 4),
            languageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 16),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            overviewLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.yellow)
        let starString = NSAttributedString(attachment: starAttachment)
        let attributedRateText = NSMutableAttributedString(string: "Rate: ")
        attributedRateText.append(NSAttributedString(string: String(format: "%.2f", viewModel.voteAverage)))
        attributedRateText.append(NSAttributedString(string: " "))
        attributedRateText.append(starString)
        rateLabel.attributedText = attributedRateText
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Trending Movie", style: .plain, target: nil, action: nil)
    }
    
    private func setupBindings() {
        viewModel.$posterImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.posterImageView.image = image
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                
                guard let self = self, let error = error else { return }
                
                self.showErrorAlert(message: error.localizedDescription)
                
            }
            .store(in: &cancellables)
        
        titleLabel.text = viewModel.movieTitle
        releaseDateLabel.text = "Release Date: \(viewModel.releaseDate)"
        languageLabel.text = "Language: \(viewModel.originalLanguage)"
        overviewLabel.text = viewModel.movieOverview
    }
    
 
}

