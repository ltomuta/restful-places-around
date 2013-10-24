/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

var InfoText =
        "<h2>RESTful Places Around 1.0</h2>"
        + "<p>This is a Nokia example demonstrating the use of Nokia RESTful "
        + "Places API within a Qt Quick application. This example retrieves "
        + "the places nearby and displays them on Nokia maps."
        + "</p>"
        + "<p>For more information and the latest version of this example, "
        + "visit <a href=\"http://projects.developer.nokia.com/restfulplacesaround\">"
        + "Nokia Developer Projects</a>.</p>";

// The marker icon dimensions are needed to adjust the position of the marker
// on the map so that the sharp end of the marker is just on top of the proper
// coordinates. The default dimensions of the Nokia Maps marker provided by the
// RESTful Places API is, at the time of writing this, 60px x 65px.
var MarkerIconWidth = 60;
var MarkerIconHeight = 65;

var DefaultBubbleWidth = 180;
var DefaultBubbleHeight = 75;
var MaxBubbleWidth = 600;
var BubbleOffset = 100; // pixels
