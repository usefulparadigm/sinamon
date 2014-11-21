// main.js

var App = (function() {

    // Models
    var Entry = Backbone.Model.extend({
        idAttribute: '_id'  // MongoDB's identifier
    });
    
    var EntryList = Backbone.Collection.extend({
        model: Entry,
        url: '/entries' 
    });

    // Views
    var EntriesView = Backbone.View.extend({
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
            $('.entries').prepend(new EntryView({model: entry}).render().el);
        }
    });
    
    var EntryView = Backbone.View.extend({
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
        template: _.template('<%= title %> \
            <a href="#" class="delete"><span class="genericon genericon-trash"></span></a> \
        '),
        render: function() {
            $(this.el).html(this.template(this.model.attributes));
            return this;
        }
    });
    
    function init() {
        var entries = new EntryList();
        new EntriesView({el: '#entries', collection: entries});
        entries.fetch({reset: true});
    };
   
    return {
        init: init
    };
}());

// DOM Ready!
$(function() {
    App.init();
});