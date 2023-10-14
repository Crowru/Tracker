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
        viewController.overrideUserInterfaceStyle = .dark
        sleep(1)
        assertSnapshot(matching: viewController, as: .image, record: reset)
        }
    func testTabBarControllerLightTheme() {
        let viewController = TabBarController()
        viewController.overrideUserInterfaceStyle = .light
        sleep(1)
        assertSnapshot(matching: viewController, as: .image, record: reset)
        }
    
    // MARK: Snapshot tests - TrackersViewController
    func testTrackersViewControllerDarkTheme() {
        let viewController = TrackerViewController()
        viewController.overrideUserInterfaceStyle = .dark
        sleep(1)
        assertSnapshot(matching: viewController, as: .image, record: reset)
        }
    func testTrackersViewControllerLightTheme() {
        let viewController = TrackerViewController()
        viewController.overrideUserInterfaceStyle = .light
        sleep(1)
        assertSnapshot(matching: viewController, as: .image, record: reset)
        }

    // MARK: Snapshot tests - ChooseTypeOfTracker
    func testChooseTypeOfTrackerDarkTheme() {
        let viewController = TrackersTypeViewController()
        viewController.overrideUserInterfaceStyle = .dark
        sleep(1)
        assertSnapshot(matching: viewController, as: .image, record: reset)
        }
    func testChooseTypeOfTrackerLightTheme() {
        let viewController = TrackersTypeViewController()
        viewController.overrideUserInterfaceStyle = .light
        sleep(1)
        assertSnapshot(matching: viewController, as: .image, record: reset)
        }

    // MARK: Snapshot tests - NewTrackerViewController
    func testNewTrackerViewControllerDarkTheme() {
        let viewController = NewTrackerViewController()
        viewController.overrideUserInterfaceStyle = .dark
        sleep(1)
        assertSnapshot(matching: viewController, as: .image, record: reset)
        }
    func testNewTrackerViewControllerLightTheme() {
        let viewController = NewTrackerViewController()
        viewController.overrideUserInterfaceStyle = .light
        sleep(1)
        assertSnapshot(matching: viewController, as: .image, record: reset)
        }

    // MARK: Snapshot tests - CategoriesViewController
    func testCategoriesViewControllerDarkTheme() {
        let viewController = CategoriesViewController()
        viewController.overrideUserInterfaceStyle = .dark
        sleep(1)
        assertSnapshot(matching: viewController, as: .image, record: reset)
        }
    func testCategoriesViewControllerLightTheme() {
        let viewController = CategoriesViewController()
        viewController.overrideUserInterfaceStyle = .light
        sleep(1)
        assertSnapshot(matching: viewController, as: .image, record: reset)
        }

    // MARK: Snapshot tests - TimetableViewController
    func testTimetableViewControllerDarkTheme() {
        let viewController = TimetableViewController()
        viewController.overrideUserInterfaceStyle = .dark
        sleep(1)
        assertSnapshot(matching: viewController, as: .image, record: reset)
        }
    func testTimetableViewControllerLightTheme() {
        let viewController = TimetableViewController()
        viewController.overrideUserInterfaceStyle = .light
        sleep(1)
        assertSnapshot(matching: viewController, as: .image, record: reset)
        }
}
