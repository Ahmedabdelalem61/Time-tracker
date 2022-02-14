import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/app/home/models/job.dart';

void main(){
  group('from-map', (){
    test('all date in job model',(){
      final job = Job.fromMap({
        'name': 'ahmed','ratePerHour':10},'abc');
      expect(job,Job(id: 'abc', name: 'ahmed', ratePerHour: 10));
    });
  });
  group('to-map', (){
    test('all date in job model',(){
      final job = Job(id: 'abc',name: 'ahmed',ratePerHour: 10);
      expect(job.toMap(),{'name':'ahmed','ratePerHour':10});
    });
  });
}
