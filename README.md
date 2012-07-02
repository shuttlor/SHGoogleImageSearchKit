SHGoogleImageSearchKit
======================

A Custome GoogleImageSearchKit

This project was commited by a Chinese iOS Engineer. 
Just for now I am doing some coding project for a iPad Application,
and I need a feature which could collect Image address from Google's 
Image Search Page.

At first I want use Google Iamge Search API. But Google Image Search API
was officially deprecated,and the number of requests you may make per day 
may be limited.So that this API is not the best choice for now.

So I did some hacking job this weekend. 

I found a opensource project on the CodeProject which addrees is 
http://www.codeproject.com/Articles/11876/An-API-for-Google-Image-Search

but it is wirtten in C#,not Obj-c.so I wrote a obj-C version.

This version has some problems such as :if Google changes the format of the 
returned HTML the parsing will fail!!!


So i make it opensource, and hope some guys whom need this feature,and could 
imporve it with me. 