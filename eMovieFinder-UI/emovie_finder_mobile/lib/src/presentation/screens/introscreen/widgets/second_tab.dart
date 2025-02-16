import 'package:flutter/material.dart';
import 'package:emovie_finder_mobile/src/style/theme/theme.dart';

class SecondTab extends StatelessWidget {
  Function changeIndexCallBack ;
  SecondTab({super.key, required this.changeIndexCallBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/images/shape2.png")
          ),
          Column(
            children: [
              Container(
                margin:const EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child:  Text(
                    "Make Your Favourite Movie Library",
                    style:Theme.of(context).textTheme.displayLarge!
                ),
              ),
              Image.asset('assets/images/image2_splash.png', width: MediaQuery.of(context).size.width * 0.8,),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                    "Watch What Ever You Want And Manage Favourite List",
                    textAlign: TextAlign.center,
                    style:Theme.of(context).textTheme.displayLarge!
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    onPressed: (){
                      changeIndexCallBack(2);
                    },
                    style: ButtonStyle(
                        elevation: WidgetStateProperty.all(0),
                        backgroundColor: WidgetStateProperty.all(MyTheme.white),
                        shape:WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ))
                    ),
                    child: Text(
                        "Next",
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(color: MyTheme.gold)
                    )
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    onPressed: (){
                      changeIndexCallBack(0);
                    },
                    style: ButtonStyle(
                        elevation: WidgetStateProperty.all(0),
                        backgroundColor: WidgetStateProperty.all(Colors.transparent),
                        shape:WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side:const BorderSide(color: Colors.white ,width: 3)
                        ))
                    ),
                    child: Text(
                        "Back",
                        style: Theme.of(context).textTheme.displayLarge
                    )
                ),
              ),
              // the three points in the end
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: MyTheme.blackFour
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: MyTheme.white
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: MyTheme.blackFour
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}