//
//  DetailSectionView.swift
//  Jamming
//
//  Created by Claire on 1/30/25.
//

import UIKit
import SnapKit

final class DetailSectionView: BaseStackView {
    private let dateIcon = UIImageView(image: UIImage(systemName: "calendar"))
    private let rateIcon = UIImageView(image: UIImage(systemName: "star.fill"))
    private let genreIcon = UIImageView(image: UIImage(systemName: "film.fill"))
    
    private let dateLabel = UILabel()
    private let rateLabel = UILabel()
    private let genreLabel = UILabel()
    
    private let separator1 = UIView()
    private let separator2 = UIView()
    
    func configureData(date: String, rate: Double, genreCodes: [Int]) {
        dateLabel.text = date
        rateLabel.text = "\(rate)"
        
        var genre: [String] = []
        genreCodes.prefix(2).forEach { code in
            let text = GenreCode.genre[code] ?? "All.Unknown".localized()
            genre.append(text)
        }
        genreLabel.text = genre.joined(separator: ", ")
    }
    
    override func configureView() {
        [dateIcon, rateIcon, genreIcon].forEach { icon in
            icon.contentMode = .scaleAspectFit
            icon.tintColor = .neutral2
        }
        
        [dateLabel, rateLabel, genreLabel].forEach { label in
            label.font = .systemFont(ofSize: 12)
            label.textColor = .neutral2
        }
        
        [separator1, separator2].forEach { separator in
            separator.backgroundColor = .neutral2
        }
    }
    
    override func setConstraints() {
        let dateStack = UIStackView()
        dateStack.addArrangedSubview(dateIcon)
        dateStack.addArrangedSubview(dateLabel)
        
        let rateStack = UIStackView()
        rateStack.addArrangedSubview(rateIcon)
        rateStack.addArrangedSubview(rateLabel)
        
        let genreStack = UIStackView()
        genreStack.addArrangedSubview(genreIcon)
        genreStack.addArrangedSubview(genreLabel)
        
        [dateStack, rateStack, genreStack].forEach { stack in
            stack.axis = .horizontal
            stack.spacing = 4
        }

        axis = .horizontal
        spacing = 12
        alignment = .center
        distribution = .fillProportionally
        
        [dateStack, separator1, rateStack, separator2, genreStack].forEach { view in
            addArrangedSubview(view)
        }
        
        separator1.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.verticalEdges.equalToSuperview()
        }
        
        separator2.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.verticalEdges.equalToSuperview()
        }
        
    }
}
