#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/ginger/main.qml"));
    //viewer.setMainQmlFile(QLatin1String("qml/ginger/qmlselection.qml"));
    viewer.setMinimumSize(QSize(640,390));
    viewer.setMaximumSize(QSize(640, 390));
    viewer.showExpanded();

    return app->exec();
}
