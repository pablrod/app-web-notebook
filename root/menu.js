require([
    "dijit/MenuBar",
    "dijit/PopupMenuBarItem",
    "dijit/Menu",
    "dijit/MenuItem",
    "dijit/DropDownMenu",
    "dojo/domReady!"
], function(MenuBar, PopupMenuBarItem, Menu, MenuItem, DropDownMenu){
    var pMenuBar = new MenuBar({});

    var pSubMenu = new DropDownMenu({});
    var menu_item = 
    pSubMenu.addChild(new MenuItem({
        label: "Save",
        iconClass: "dijitEditorIcon dijitEditorIconSave",
        onClick: function () {
            dojo.xhrPost({
                url: "save",
                handleAs: "json",
                content: {
                    "notebook_id" : notebook_id
                },
                load: function(response) {
                    alert("Guardado correctamente");
                    },
                error: function() {
                    // Do Nothing
                    alert("No se ha podido guardar");
                }
            });
        }
    }));
    pMenuBar.addChild(new PopupMenuBarItem({
        label: "Notebook",
        popup: pSubMenu
    }));

    pMenuBar.placeAt("notebook_menu");
    pMenuBar.startup();
});

