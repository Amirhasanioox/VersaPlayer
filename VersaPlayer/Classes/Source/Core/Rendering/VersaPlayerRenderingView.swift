//
//  VPlayerRenderingView.swift
//  VersaPlayer Demo
//
//  Created by Jose Quintero on 10/11/18.
//  Copyright © 2018 Quasar. All rights reserved.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif
import AVKit

open class VersaPlayerRenderingView: View {

  #if os(iOS)
  override open class var layerClass: AnyClass {
      return AVPlayerLayer.self
  }
  #endif

  public var playerLayer: AVPlayerLayer {
      return layer as! AVPlayerLayer
  }

  /// VersaPlayer instance being rendered by renderingLayer
  public weak var player: VersaPlayerView!

  deinit {
    #if DEBUG
    print("6 \(String(describing: self))")
    #endif
  }

  /// Constructor
  ///
  /// - Parameters:
  ///     - player: VersaPlayer instance to render.
  public init(with player: VersaPlayerView) {
    super.init(frame: CGRect.zero)
    NotificationCenter.default.addObserver(self, selector: #selector(self.appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    playerLayer.player = player.player
  }
    
    private var _player: AVPlayer?
    @objc private func appDidEnterBackground() {
        self._player = self.playerLayer.player
        self.playerLayer.player = nil
    }
    @objc private func appWillEnterForeground() {
        self.playerLayer.player = self._player
        self._player = nil
    }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  #if os(macOS)

  override open func makeBackingLayer() -> CALayer {
    return playerLayer
  }

  #endif

}
