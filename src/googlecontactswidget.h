#ifndef GOOGLECONTACTSWIDGET_H
#define GOOGLECONTACTSWIDGET_H

#include <QQuickWidget>
#include <QQuickItem>
#include <QQmlContext>
#include <QZXing.h>
#include "qgooglewrapper.h"

class GoogleContactsWidget : public QQuickWidget
{
    Q_OBJECT
private:
    QGoogleWrapper* wrapper;

public:
    GoogleContactsWidget(QQmlEngine* engine, QWidget* parent = nullptr);
    void setup();

signals:
    void log(QString const& log);

};

#endif // GOOGLECONTACTSWIDGET_H
