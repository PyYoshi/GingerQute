// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "ginger_api.js" as Ginger

Rectangle {
    width: 640
    height: 390
    color: "#ecebeb"
    radius: 0

    Text {
        id: appLabel
        x: 29
        y: 14
        text: "Start proofreading your text now"
        font.bold: true
        font.family: "Bitstream Charter"
        font.pointSize: 14
        color: "grey"
        smooth: true
    }
    Rectangle {
        id: rawTextRectangle
        x: 30
        y: 55
        width: 580
        height: 130
        color: "#ffffff"
        radius: 20
        border.width: 3
        border.color: "#c4bbbb"
        Flickable {
            id: rawTextFlickable
            anchors.fill: parent
            contentWidth: rawTextEdit.paintedWidth
            contentHeight: rawTextEdit.paintedHeight
            interactive: true
            clip: true
            TextEdit {
                id: rawTextEdit
                x: 15
                y: 10
                width: 550
                height: 104
                text: ""
                smooth: true
                wrapMode: TextEdit.Wrap
                textFormat: TextEdit.PlainText
                transformOrigin: Item.Center
                cursorVisible: true
                opacity: 1
                font.family: "Bitstream Charter"
                font.pointSize: 17
                focus: true
            }
        }
    }

    Rectangle {
        id: correctTextRectangle
        x: 30
        y: 225
        width: 580
        height: 130
        color: "#ffffff"
        radius: 20
        border.width: 3
        border.color: "#c4bbbb"
        Flickable {
            id: correctFlickable
            anchors.fill: parent
            contentWidth: correctTextEdit.paintedWidth
            contentHeight: correctTextEdit.paintedHeight
            interactive: true
            clip: true
            TextEdit {
                id: correctTextEdit
                x: 15
                y: 10
                width: 548
                height: 104
                text: ""
                smooth : true
                wrapMode: TextEdit.Wrap
                textFormat: TextEdit.AutoText
                font.family: "Bitstream Charter"
                font.pointSize: 17
                focus: false
            }
        }
    }

    Rectangle {
        id: gingerButtonRectangle
        x: 229
        y: 174
        width: 183
        height: 61
        color: "#201f1f"
        radius: 20
        border.width: 5
        border.color: "#2f2e2e"
        smooth : true
        /*
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#808080"
            }

            GradientStop {
                position: 1
                color: "#2d2d2d"
            }
        }
        */
        MouseArea {
            id: gingerButtonMouseArea
            x: 0
            y: 0
            width: 183
            height: 61
            hoverEnabled: true
            Text {
                id: gingerButtonText
                x: 0
                y: 0
                width: 183
                height: 62
                color: "#ffffff"
                text: qsTr("Ginger it!")
                horizontalAlignment: Text.AlignHCenter
                font.underline: false
                font.bold: true
                font.family: "Bitstream Charter"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 36
            }
            onPressed: {
                correctTextEdit.text = ''
                if(rawTextEdit.text.length !== 0){
                    var ginger = new Ginger.GingerAPI()
                    var api_url = ginger.build_url(rawTextEdit.text)
                    var xhr = new XMLHttpRequest()
                    xhr.open('GET', api_url, true)
                    xhr.onreadystatechange = function(){
                        if (xhr.readyState === 4 && xhr.status === 200){
                            var json = JSON.parse(xhr.responseText)
                            var result = ginger.parse(rawTextEdit.text, json)
                            rawTextEdit.text = qsTr(result[1].replace(/(<([^>]+)>)/ig,""))
                            correctTextEdit.text = qsTr(result[0])
                        }else if (xhr.readyState === 4 && xhr.status !== 200){

                        }
                    }
                    xhr.send(null)
                }
            }
        }
        states: [
            State {
                name: "Press"
                when: gingerButtonMouseArea.pressed
                PropertyChanges {
                    target: gingerButtonRectangle
                    // TODO: ボタンを押した時の挙動追加
                    color: "#696969"
                    border.color: "#D3D3D3"
                }
                PropertyChanges {
                    target: gingerButtonText
                    // TODO: ボタンにマウスを重ねた時の挙動追加
                    color: "#ADFF2F"
                }
            },
            State {
                name: "Hover"
                when: gingerButtonMouseArea.containsMouse
                PropertyChanges {
                    target: gingerButtonText
                    // TODO: ボタンにマウスを重ねた時の挙動追加
                    color: "#ADFF2F"
                }
            }
        ]
    }

    Component.onCompleted: {

    }
}
