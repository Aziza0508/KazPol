//
//  ViewController.swift
//  PoliceApp
//
//  Created by Aziza Gilash on 29.03.2025.
//

import UIKit
import AVFoundation
import Photos
import CoreLocation

class IncidentReportViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    // UI Elements
    let imageView = UIImageView()
    let descriptionTextView = UITextView()
    let selectMediaButton = UIButton()
    let submitButton = UIButton()
    
    // Media & Location Variables
    var selectedImage: UIImage?
    var selectedVideoURL: URL?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
    }

    func setupUI() {
        view.backgroundColor = .white

        // ImageView setup
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(hex: "#ededed")
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // TextView setup
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false

        // Select Media Button
        selectMediaButton.setTitle("Attach Photo/Video", for: .normal)
        selectMediaButton.setTitleColor(.white, for: .normal)
        selectMediaButton.backgroundColor = UIColor(hex: "#3c3d79")
        selectMediaButton.layer.cornerRadius = 8
        selectMediaButton.addTarget(self, action: #selector(selectMediaTapped), for: .touchUpInside)
        selectMediaButton.translatesAutoresizingMaskIntoConstraints = false

        // Submit Button
        submitButton.setTitle("Submit Report", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = UIColor(hex: "#D2042D")
        submitButton.layer.cornerRadius = 8
        submitButton.addTarget(self, action: #selector(submitReport), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false

        // Add Subviews
        view.addSubview(imageView)
        view.addSubview(descriptionTextView)
        view.addSubview(selectMediaButton)
        view.addSubview(submitButton)

        // Constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            descriptionTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),

            selectMediaButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            selectMediaButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectMediaButton.widthAnchor.constraint(equalToConstant: 200),
            selectMediaButton.heightAnchor.constraint(equalToConstant: 50),

            submitButton.topAnchor.constraint(equalTo: selectMediaButton.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func selectMediaTapped() {
        let actionSheet = UIAlertController(title: "Attach Media", message: "Choose an option", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo/Video", style: .default) { [weak self] _ in
            self?.presentMediaPicker(sourceType: .camera)
        }
        
        let libraryAction = UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.presentMediaPicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }

    func presentMediaPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.mediaTypes = ["public.image", "public.movie"]
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imageView.image = image
            selectedVideoURL = nil
        } else if let videoURL = info[.mediaURL] as? URL {
            selectedVideoURL = videoURL
            imageView.image = UIImage(named: "video_thumbnail")
        }
        
        picker.dismiss(animated: true)
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
        }
    }
    
    @objc func submitReport() {
        guard let description = descriptionTextView.text, !description.isEmpty else {
            showAlert(title: "Error", message: "Please enter a description.")
            return
        }
        
        let latitude = currentLocation?.coordinate.latitude ?? 0.0
        let longitude = currentLocation?.coordinate.longitude ?? 0.0
        
        // Prepare the report data
        var reportData: [String: Any] = [
            "description": description,
            "latitude": latitude,
            "longitude": longitude
        ]
        
        if let image = selectedImage {
            reportData["image"] = image.pngData() // Convert image to data
        } else if let videoURL = selectedVideoURL {
            reportData["videoURL"] = videoURL.absoluteString
        }
        
        print("Report Submitted: \(reportData)")
        showAlert(title: "Success", message: "Incident report submitted successfully.")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
    }
}
