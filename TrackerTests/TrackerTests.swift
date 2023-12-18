//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Руслан  on 14.10.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    // MARK: You can reset all results
    let reset = false
    
    // MARK: Snapshot tests - TabBarController(Main screen)
    func testTabBarControllerDarkTheme() {
        let viewController = TabBarController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)), record: reset)
    }
    func testTabBarControllerLightTheme() {
        let viewController = TabBarController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .light)), record: reset)
    }
    
    // MARK: Snapshot tests - TrackersViewController
    func testTrackersViewControllerDarkTheme() {
        let viewController = TrackerViewController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)), record: reset)
    }
    func testTrackersViewControllerLightTheme() {
        let viewController = TrackerViewController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .light)), record: reset)
    }
    
    // MARK: Snapshot tests - ChooseTypeOfTracker
    func testChooseTypeOfTrackerDarkTheme() {
        let viewController = TrackersTypeViewController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)), record: reset)
    }
    func testChooseTypeOfTrackerLightTheme() {
        let viewController = TrackersTypeViewController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .light)), record: reset)
    }
    
    // MARK: Snapshot tests - NewTrackerViewController
    func testNewTrackerViewControllerDarkTheme() {
        let viewController = NewTrackerViewController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)), record: reset)
    }
    func testNewTrackerViewControllerLightTheme() {
        let viewController = NewTrackerViewController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .light)), record: reset)
    }
    
    // MARK: Snapshot tests - CategoriesViewController
    func testCategoriesViewControllerDarkTheme() {
        let viewController = CategoriesViewController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)), record: reset)
    }
    func testCategoriesViewControllerLightTheme() {
        let viewController = CategoriesViewController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .light)), record: reset)
    }
    
    // MARK: Snapshot tests - TimetableViewController
    func testTimetableViewControllerDarkTheme() {
        let viewController = TimetableViewController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)), record: reset)
    }
    func testTimetableViewControllerLightTheme() {
        let viewController = TimetableViewController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .light)), record: reset)
    }
}
