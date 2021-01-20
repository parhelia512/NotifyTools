#include <iostream>
#include <string>
// #define CPPHTTPLIB_OPENSSL_SUPPORT
#include "httplib.h"
using namespace std;
using namespace httplib;
/*
openssl-1.1.1i/apps/CA.pl
./CA.pl -newcert 88888888 cn
Cert is in newcert.pem, private key is in newkey.pem
*/
#define SERVER_CERT_FILE        "./newcert.pem"
#define SERVER_PRIVATE_KEY_FILE "./newkey.pem"

std::string dump_headers(const Headers& headers)
{
    std::string s;
    char buf[BUFSIZ];

    for (auto it = headers.begin(); it != headers.end(); ++it)
    {
        const auto& x = *it;
        snprintf(buf, sizeof(buf), "%s: %s\n", x.first.c_str(), x.second.c_str());
        s += buf;
    }

    return s;
}
void helloword(const httplib::Request& req, httplib::Response& rsp)
{
    printf("httplib server recv a req: %s %s\n ", req.path.c_str(), req.remote_addr.c_str());
    // std::string str = R "( <html  lang= ><h1> 武汉, 加油！</h1></html>)";
    // std::string s1 = R "a(C:\Users\Administrator\Desktop\RWtest\write.txt)a";
    std::string s= R"foo(
C:\Users\Administrator\Desktop\RWtes
    )foo";
    const char* s1 = R"foo(
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
</head>
<h1> 武汉, 加油！</h1></html>
)foo";
    rsp.set_content(s, "text/html"); //最后一个参数是正文类型
    rsp.status = 200;
}
void helloword1(const httplib::Request& req, httplib::Response& rsp)
{
    printf("httplib server recv a req: %s %s\n ", req.path.c_str(), req.remote_addr.c_str());
    dump_headers(req.headers);
    // std::string str = R "( <html  lang= ><h1> 武汉, 加油！</h1></html>)";
    // std::string s1 = R "a(C:\Users\Administrator\Desktop\RWtest\write.txt)a";
    std::string s= R"foo(
C:\Users\Administrator\Desktop\RWtes
    )foo";
    const char* s1 = R"AAA(
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
</head>
<h1> 武汉, 加油！</h1></html>
)AAA";
    rsp.set_content(s1, "text/html"); //最后一个参数是正文类型
    rsp.status = 200;
}

int main(int argc, char** argv)
{
#ifdef CPPHTTPLIB_OPENSSL_SUPPORT
    SSLServer srv(SERVER_CERT_FILE, SERVER_PRIVATE_KEY_FILE);
#else
    Server srv;
#endif
    if (srv.is_valid() == false)
    {
        printf("err init!");
    }
    srv.Get("/", helloword1);
    srv.Get("^/.*$", helloword);

    srv.listen("0.0.0.0", 9000);

    getchar();
    return 0;
}