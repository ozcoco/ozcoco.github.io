

// write file, succese return string data, other return -1

function fread(path) {

    var fs;

    var file;

    try {

        fs = new ActiveXObject("Scripting.FileSystemObject");

        file = fs.OpenTextFile(path);

        return file.ReadAll();

    } catch (e) {
        alert("当前浏览器不支持");
        return -1;
    }
    finally {

        file.Close();

    }
}



function readTextFile(file, callback)
{
    var rawFile = new XMLHttpRequest();

    rawFile.open("GET", file, false);

    rawFile.onreadystatechange = function ()
    {
        if(rawFile.readyState === 4)
        {
            if(rawFile.status === 200 || rawFile.status == 0)
            {
                var allText = rawFile.responseText;

                alert(allText);

                callback(allText);

            }
        }
    }

    rawFile.send(null);
}




// write file, succese return 0, other return not zero

function fwrite(pathname, content) {

    var fs;

    var file;

    try {

        fs = new ActiveXObject("Scripting.FileSystemObject");

        file = fs.createtextfile(pathname, true);

        file.Write(content);

        return 0;

    } catch (e) {

        alert("当前浏览器不支持");

        return -1;
    }
    finally {

        file.Close();

    }

}