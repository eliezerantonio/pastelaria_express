import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class CreditCardWidget extends StatefulWidget {
  final Function(String) onPressed;
  final Function(String) onPressed2;
  final String reference;

  const CreditCardWidget(
      {Key key, this.onPressed, this.onPressed2, this.reference})
      : super(key: key);
  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberFocus = FocusNode();

  final FocusNode dateFocus = FocusNode();

  final FocusNode nameFocus = FocusNode();

  final FocusNode pinFocus = FocusNode();

  bool side = false;
  bool show = false;
  String userChoice;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FlipCard(
              key: cardKey,
              speed: 700,
              flipOnTouch: false,
              front: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Container(
                  height: 200,
                  color: const Color.fromRGBO(255, 128, 128, 0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RadioListTile(
                                activeColor:
                                    Theme.of(context).colorScheme.secondary,
                                title: const Text(
                                  "IBAM",
                                  maxLines: 1,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: const Text(
                                  "Transferencia",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                                groupValue: userChoice,
                                onChanged: (s) {
                                  setState(() {
                                    userChoice = s as String;
                                  });
                                  widget.onPressed(s as String);
                                },
                                value: "IBAM",
                              ),
                            ),
                            const Divider(),
                            Expanded(
                              child: RadioListTile(
                                contentPadding: EdgeInsets.zero,
                                activeColor:
                                    Theme.of(context).colorScheme.secondary,
                                title: const Text(
                                  "Dinheiro",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                                subtitle: const Text(
                                  "Na Entrega",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                                groupValue: userChoice,
                                onChanged: (s) {
                                  setState(() {
                                    userChoice = s as String;

                                    // getEkwanzaValues();
                                  });
                                  widget.onPressed(s as String);
                                },
                                value: "DINHEIRO",
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ///////////////////////BACK_CARD///////////////////////////
              back: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 20,
                child: Container(
                  height: 200,
                  color: const Color.fromRGBO(255, 128, 128, 0),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.black,
                        height: 40,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
                              title: const Text(
                                "Referência",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              groupValue: userChoice,
                              onChanged: (s) {
                                setState(() {
                                  userChoice = s as String;
                                  // getEkwanzaValues();
                                });
                                widget.onPressed(s as String);
                              },
                              value: "REFERENCIA",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: RadioListTile(
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
                              title: const Text(
                                "TPA",
                                maxLines: 1,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: const Text(
                                "Na Entrega",
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                              groupValue: userChoice,
                              onChanged: (s) {
                                setState(() {
                                  userChoice = s as String;
                                });
                                widget.onPressed(s as String);
                              },
                              value: "TPA",
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
                              title: const Text(
                                "Dinheiro",
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                              subtitle: const Text(
                                "Na Entrega",
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                              groupValue: userChoice,
                              onChanged: (s) {
                                setState(() {
                                  userChoice = s as String;

                                  // getEkwanzaValues();
                                });
                                widget.onPressed(s as String);
                              },
                              value: "DINHEIRO",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (side)
              FlatButton(
                textColor: Colors.white,
                padding: EdgeInsets.zero,
                onPressed: () {
                  cardKey.currentState.toggleCard();
                  setState(() {
                    show = !show;
                  });
                },
                child: const Text(
                  "Voltar",
                  style: TextStyle(color: Colors.black),
                ),
              )
            else
              Container()
          ],
        ));
  }
}
