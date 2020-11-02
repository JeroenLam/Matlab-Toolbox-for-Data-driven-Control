# Matlab-Toolbox-for-Data-driven-Control
When studying systems and control theory we often focus on finding properties of a given mathematical model. However, in the real world the mathematical model of a system is not always available. In most cases we only have the measurements/data as produced by a system. To combat this, we can use tools from the field of data-driven analysis and control. These tools are able to infer system theoretical properties from the data without explicitly knowing the underlying mathematical model of the system.

Since we only have access to the data (e.g. state and input), we can not necessarily determine the model that describes this data uniquely. 
It might be the case that there are an infinite amount of different mathematical models describing the same data.
However, if we were to be able to show that a property holds for all of these models that describe the data, then we can conclude that the property holds for the true system as well. This is also defined as informativity. We say the data are informative for a system theoretic property if that property holds for all models describing the data. 

However, constructing a set of all possible models describing the data and then showing that a property holds for each of those models becomes unpractical very quickly. 
Luckily, better methods were developed to more easily show data informativity without computing all possible models. 
In this project we will implement these methods in a Matlab toolbox.

## To do
https://trello.com/b/c7ulvv6Q/matlab-toolbox-for-data-driven-control

##Problem

When applying methods from systems and control to an actual problem, computers are often needed due to the complexity and size of the systems and data. Thus, in this project we will start development on a Matlab toolbox based on the necessary and sufficient condition as well as the methods discussed in (at least) the papers, "\textit{Data informativity: a new perspective on data-driven analysis and control}" \cite{waarde2019data} and "\textit{From noisy data to feedback controllers: non-conservative design via a matrix S-lemma}" \cite{waarde2020noisy}. These papers discuss how to determine if certain system theoretic properties hold (the specific properties will be discussed later on) as well as methods on how to construct and compute controllers for multiple forms of feedback and stabilisation.

In the case of perfect data, we will look at the algorithms to determine stabilizability and controllability as well as system identification.
We will also look at the algorithms to determine existence of controllers for deadbeat control, stabilisation by state feedback, linear quadratic regulation and stabilisation by dynamic measurement feedback as well as the construction of these controllers. 
We will implement these algorithms as well as providing documentation on the implementation and efficiency of all the functions.

Similar to the perfect data case, we will look at the provided algorithms to compute controllers for quadratic stabilisation, $\mathcal{H}_2$ control and $\mathcal{H}_\infty$ control in cases where the data are affected by bounded noise. We will also implement these algorithms as well as providing documentation on their implementation and efficiency. 

As noted earlier, to ensure the ease of use of the toolbox we will provide extensive documentation on each function as well as examples. We will also try to make the toolbox as flexible as possible. Specifically, we will not be hard-coding any solvers, since the efficiency of solvers is always increasing. This will ensure that the toolbox will remain useful. In case there is time left, we will also look at valid test data generators as well as incorporating algorithms for data-driven pole placement.
