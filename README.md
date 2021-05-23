# Ship of Theseus

The ship wherein Theseus and the youth of Athens returned from Crete had thirty oars, and was preserved by the Athenians down even to the time of Demetrius Phalereus, for they took away the old planks as they decayed, putting in new and stronger timber in their places, insomuch that this ship became a standing example among the philosophers, for the logical question of things that grow; one side holding that the ship remained the same, and the other contending that it was not the same.

-Plutarch, Theseus

Ship of Theseus is philosopical question on which the jury is still out. It questions the identity of the whole in relation to its parts. A similar philosophical puzzle is also found in Sanskrit Buddhist text titled Mahāprajñāpāramitopadeśa.

While our civilization still discusses the puzzle, I have tried to answer a more objective question: if we change a body's parts randomly (can be anything, like a ship in this app) at the rate of X% till we have changed Y% of the body, how long will the process take. I have developed a Monte Carlo to answer this question. The first slider 'Percentage Change' is the X quantity and the second slider 'Overall Change Limit' is Y quantity.

The plot of ship shows a visual of the ship with Y% parts changed, and the density plot shows the distribution of the number of changes at X% per change that the simulation took to replace the Y% of the parts.

The app is hosted at: 

Those who are interested in understanding the details of the simulation are welcome to look at the code behind the app in this GitHub repository.

What's the use? One way I have imagined this information can be useful is for organizations to introspect how long does it take for their organizations to have half of their employees change? The introspection can be useful in understanding cultural changes or any change that accompanies churn of employees. So to answer this question, set the first slider to whatever is the attrition rate of your company, let's say 5% and set the second slider to 50%. Hit the simulation button, and the answer appears to be 14 years. 

So feel free to use the application's answer to your business case or, maybe, answer some curious questions. 


Ashwini Jha 
Senior Data Scientist
