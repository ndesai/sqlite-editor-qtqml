#!/bin/bash

# Generate qrc

QMLBASEDIR=qml
TMPQRC=.qml.qrc
QRC=qml.qrc

#<RCC>
#    <qresource prefix="/">
#        <file>main_ios.qml</file>
#        <file>home.qml</file>
#        <file>dev.qml</file>
#        <file>img/triangular.png</file>
#    </qresource>
#</RCC>

{
	echo "<RCC>"
	echo -ne '\t'
	echo "<qresource prefix=\"/\">"
	for i in `find ${QMLBASEDIR} -type f | grep -v .DS_Store`; 
		do
			echo -ne '\t\t'
			echo "<file>${i}</file>"
	done;
	echo -ne '\t'
	echo "</qresource>"
	echo "</RCC>"
} >> ${TMPQRC}


mv ${TMPQRC} ${QRC} 
cat ${QRC}
