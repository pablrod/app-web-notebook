var cells = 0;
var editors = {};

function EvaluateResultScripts(id) {
	var cell_result = dojo.byId(id);
    var scripts = cell_result.getElementsByTagName('script');
    for (var script_index = 0; script_index < scripts.length; script_index++) {
    	eval(scripts[script_index].innerHTML);
    }
}

    function ExecuteCell(cell_id) {
        var cell_content = editors[cell_id];
        dojo.xhrPost({
                url: "execute_json",
                handleAs: "json",
                content: {"cell_id" : cell_id,
                    "notebook_id" : notebook_id,
                    code : cell_content.getDoc().getValue()
                },
                load: function(newContent) {
                	var result_id = "result" + cell_id;
                	var cell_result = dojo.byId(result_id);
                    cell_result.innerHTML = newContent.result;
                	EvaluateResultScripts(result_id);
                    },
                error: function() {
                    // Do Nothing
                }
                });
    }
    function AddCell(after_cell_id, content, result) {
    	content = typeof content !== 'undefined' ? content : "";
    	result = typeof result !== 'undefined' ? result : "";
        cells = cells + 1;
        var div = document.createElement('div');
        div.id = "cell_" + cells;
        div.innerHTML = "<textarea id=" + cells + " name=code>" + content + "</textarea><button onclick=\"ExecuteCell(" + cells + ")\">Ejecutar</button><div id=result" + cells + ">" + result + "</div>";
        var after_cell = document.getElementById("cell_" + after_cell_id);
        if (after_cell != null) {
            after_cell.parentNode.insertBefore(div, after_cell.nextSibling);
        } else {
            document.body.insertBefore(div, document.body.lastChild);
        }
        editors[cells] = CodeMirror.fromTextArea(document.getElementById(cells), {
    lineNumbers: true
  });
        var cell = "" + cells;
        editors[cells].setOption("extraKeys", {
                "Shift-Enter" : function(cm) {
                    ExecuteCell(cm.getTextArea().id);
                },
                "Alt-Enter" : function(cm) {
                    AddCell(cell);
                    }
                });

        EvaluateResultScripts("result" + cells);
    }
    


function LoadNotebook(notebook_id) {
    dojo.xhrPost({
        url: "notebook_model",
        handleAs: "json",
        content: {"notebook_id": notebook_id},
        load: function (content) {
            var cells = content.notebook.worksheets[0]; 
            for (var cell_index = 0; cell_index < cells.length; cell_index++) {
            	AddCell(null, cells[cell_index].code, cells[cell_index].result);
            }
        },
        error: function () {
            AddCell();
        }
    });
}

