import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/common_widgets/custom_raised_button.dart';

void main(){
  testWidgets('callback of onpress testing', (WidgetTester tester)async{
    bool pressed = false;
    await tester.pumpWidget(MaterialApp(home: CustomRaisedButton(
      onPressed: () => pressed = true,
      child: const Text('test'),
    )));
    expect(find.byType(RaisedButton), findsOneWidget);
    expect(find.byType(FlatButton), findsNothing);
    expect(find.text('test'), findsOneWidget);
    await tester.tap(find.byType(RaisedButton));
    expect(pressed, true);
  });
}