import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Universal 2.0

Item {
    width: 800
    height: 700

    property var selectedTransactions: []

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        spacing: 0

        ToolBar {
            height: 48
            z: 8

            Layout.fillWidth: true
            Material.elevation: 4

            RowLayout {
                id: topRow
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 8

                TextField {
                    id: textField
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter

                    placeholderText: "Filter by tags or name"
                }

                Label {
                    text: qsTr("From")
                    leftPadding: 16
                    Layout.alignment: Qt.AlignVCenter
                    verticalAlignment: Text.AlignTop
                }

                ComboBox {
                    id: fromDatePicker
                    Layout.alignment: Qt.AlignVCenter
                }

                Label {
                    text: qsTr("To")
                    Layout.alignment: Qt.AlignVCenter
                }

                ComboBox {
                    id: toDatePicker
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }

        ListView {
            id: transactionsListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 4
            Layout.rightMargin: 4

            spacing: 12
            model: transactionsModel

            delegate: TransactionDelegate {
                width: parent.width
                Material.elevation: 1

                onTransactionSelected: {
                    selectedTransactions.push(selectedTransaction)
                    selectedTransactionsChanged()
                }

                onTransactionUnselected: {
                    var index = selectedTransactions.indexOf(unselectedTransaction)
                    if (index > -1) {
                        selectedTransactions.splice(index, 1)
                        selectedTransactionsChanged()
                    }
                }
            }
        }

        Pane {
            id: batchTagsPane
            Layout.fillWidth: true
            height: 56

            Material.elevation: 1

            visible: selectedTransactions.length > 0
            transform: yTranslation

            Translate {
                id: yTranslation
                y: batchTagsPane.visible ? 0 : 56

                Behavior on y {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: batchTagsPane.leftPadding

                TextField {
                    id: batchTagsTextField
                    Layout.fillWidth: true
                    placeholderText: "Add your tags here..."
                }

                Button {
                    id: applyBatchTagsButton
                    text: qsTr("Apply to %L1 transactions").arg(selectedTransactions.length)

                    onClicked: {
                        dbDao.applyTags(selectedTransactions, batchTagsTextField.text)
                    }
                }
            }
        }
    }
}
