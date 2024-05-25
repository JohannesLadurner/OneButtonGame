extends Node

class_name JavaScriptFileReader

func select_file_data() -> PackedByteArray:
	JavaScriptBridge.eval("""
		var input = document.createElement('input');
		input.type = 'file';
		input.onchange = e => { 
			var file = e.target.files[0]; 
			var reader = new FileReader();
			reader.readAsArrayBuffer(file);
			
			reader.onload = async readerEvent => {
				var filecontent = readerEvent.target.result; // this is the content!
				var img = document.createElement('img');
				img.id = "output";
				img.data = filecontent;
				document.body.appendChild(img);
			}
		}
		input.click();
	""")
	var result
	while true:
		await get_tree().create_timer(1).timeout
		result = JavaScriptBridge.eval("""(function () {
		var output = document.getElementById("output")
		if (output!== null) {
			console.log("output found")
			return output.data
		}
		return null
	})() """)
		if result != null:
			break
	
	JavaScriptBridge.eval("""(function () {
		document.getElementById("output").remove();
	})() """)
	return result
