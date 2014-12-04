/*global bingo, Backbone, JST*/

sinamon.Views = sinamon.Views || {};

(function () {
    'use strict';

    sinamon.Views.EntriesView = Backbone.View.extend({

        // el: '#entries',
        events: {
            'submit form': 'submit'
        },
        submit: function() {
            var $form = this.$el.find('form');
            var data = $form.serializeObject();
            // console.dir(data);
            this.collection.create(data);
            $form[0].reset();    
            return false;
        },
        initialize: function() {
            this.listenTo(this.collection, 'reset', this.render);
            this.listenTo(this.collection, 'add', this.add);
        },
        render: function() {
            this.collection.forEach(this.add, this);
            return this;
        },
        add: function(entry) {
            // console.log(entry);
            $('.entries').prepend(new sinamon.Views.EntryView({model: entry}).render().el);
        }

    });

})();
