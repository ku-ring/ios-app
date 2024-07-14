//
//  ContextRequestHandler.swift
//  s
//
//  Created by Geon Woo lee on 7/14/24.
//

import ClassKit

class ContextRequestHandler: NSObject, NSExtensionRequestHandling, CLSContextProvider {

    func beginRequest(with context: NSExtensionContext) {
        // This is a required function defined by the NSExtensionRequestHandling protocol. This function
        // will be called once per connection from a host. Therefore, it may be called several times, if
        // the host disconnects and reconnects several times. This is where you can have code that performs
        // one-time initialization.
    }

    func updateDescendants(of context: CLSContext, completion: @escaping (Error?) -> Void) {
        let error: Error? = nil

        // This is where your code creates child contexts for the context passed in.
        // If there is nothing to do, call the completion (below) and you're done.
        //
        // Otherwise, create children, add them to context and then -[CLSDataStore saveWithCompletion:].
        //
        // If your extension is being called, an instructor is probably creating a Handout and actively
        // browsing for quizzes/activities. Your extension should try to update your context tree quickly.
        // Note: your call to -[CLSDataStore saveWithCompletion:] will likely trigger a refresh of the
        // available quizzes/activities, so call it as soon as you can.

        // Call completion when you are finished.
        completion(error)
    }
}
