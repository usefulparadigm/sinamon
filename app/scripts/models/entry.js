/*global sinamon, Backbone*/

sinamon.Models = sinamon.Models || {};

(function () {
    'use strict';

    sinamon.Models.Entry = Backbone.Model.extend({
        idAttribute: '_id'  // MongoDB's identifier
    });

})();
