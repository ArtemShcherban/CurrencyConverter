Application

Сreate an application for quick assessment of the current exchange rate.

Extra*. Add the ability to view the national bank exchange rate on the selected day for the past year.



Required functionality

Add an input field for evaluating the sale / purchase of selected foreign currency by the user.
The layout of the application should be adapted for different devices (iPhone / iPad) and orientation (portrait / landscape).
It is necessary to display the buy / sell rate relative to 2-3 major foreign currencies in the country. First – country currency.
Provide work offline.
Update the exchange rate no more than once an hour.
Add the ability to share the exchange rate of selected currency to country currency in messengers and more.
Min iOS 14.


Stack

Swift
UIKit
Storyboard
Auto Layout
Trait collections
URLSession
Codable
Repository pattern
Third-party API
MVC
Design instruments: Figma


Additions & explanations

Use any free public APIs to get exchange rate, for example: https://api.privatbank.ua/#p24/exchange

Design: 

https://www.figma.com/file/yt2U4Dg7FNMzmNf3ZVlgJm/Currency-converter

Use elements from the “Text fields” task.

Hint*. For example, if the exchange rate was updated at 8:24, then the next update from the network should only be requested after 9:00. If the update fails, display the update time.

Extra*. If the exchange rate was requested for a specified day, then the next display should be from a local copy.
