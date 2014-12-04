/*global Sinamon, Backbone, JST*/

sinamon.Views = sinamon.Views || {};

(function () {
    'use strict';

    sinamon.Views.EntryView = Backbone.View.extend({

        tagName: "p",
        className: "entry bg-info",
        events: {
            'click .delete': 'deleteEntry'
        },
        deleteEntry: function() {
            this.model.destroy(); // delete model
            return false;
        },
        initialize: function() {
            this.listenTo(this.model, 'destroy', this.remove); // call view.remove()
        },
        template: _.template('{{title}}' +
            '<a href="#" class="delete"><span class="genericon genericon-trash"></span></a>'),
        render: function() {
            $(this.el).html(this.template(this.model.attributes));
            return this;
        }

    });

})();
