���� XML2CPP CXX

������˸� artifacts MyEclipse \Uninstaller\settings\uninstaller\artifacts.xml

1.1
���� codesynthesis demo ��Ҫ xerces

���� https://xerces.apache.org/xerces-c/build-3.html ��������ƺ���Щ�鷳������ʱ������

һ vs csd

https://www.cnblogs.com/qq260250932/p/4245376.html
 xsd.exe test.xml
ֱ�ӿ�ס���������

https://stackoverflow.com/questions/59132321/generate-xml-schema-xsd-to-c-class
xsd /language:CPP your.xsd /classes

https://stackoverflow.com/questions/20545224/web-application-build-error-the-codedom-provider-type-microsoft-visualc-cppcode
gacutil /i "path to CppCodeProvider.dll"

���ɵ� artifacts.h ������ �������й�c++���룬���������

�� trang.jar
https://blog.csdn.net/luoww1/article/details/47272651

https://github.com/relaxng/jing-trang
��˵��ant��������jar
java -jar trang.jar  person.xml  person.xsd
���� artifacts.xsd

https://www.pianshen.com/article/82141100699/

https://www.codesynthesis.com/products/xsd/download.xhtml
���� xsd-4.0.0-x86_64-linux-gnu.tar.bz2

./xsd cxx-tree artifacts.xsd
./xsd cxx-parser artifacts.xsd

���ɸ�hxx cxx �ļ�

