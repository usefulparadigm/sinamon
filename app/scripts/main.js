/*global App, $*/

// Change Underscore's default delimiters
// 'cause ERB-style delimiters aren't my cup of tea
// http://documentcloud.github.io/underscore/#template
_.templateSettings = {
    interpolate: /\{\{(.+?)\}\}/g
};

window.sinamon = {
    Models: {},
    Collections: {},
    Views: {},
    Routers: {},
    init: function () {
        'use strict';
        console.log('Hello from Backbone!');

        new this.Routers.AppRouter();
        Backbone.history.start();
    }
};

$(document).ready(function () {
    'use strict';
    sinamon.init();
});
