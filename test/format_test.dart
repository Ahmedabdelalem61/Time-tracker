
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/app/home/job_entries/format.dart';

void main(){
  group('hours', () {
    test('psotive', (){
      expect(Format.hours(1), '1h');
    });  
    test('zero', (){
      expect(Format.hours(0), '0h');
    });
    test('negative', (){
      expect(Format.hours(-1), '0h');
    }); 
    test('decimal', (){
      expect(Format.hours(1.5), '1.5h');
    }); 
  });


  group('date-GB', (){
    setUp(()async{
      Intl.defaultLocale = 'en-GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('2018-8-4', (){
      expect(Format.date(DateTime(2018,8,4)), '4 Aug 2018');
    });
    test('2022-8-4', (){
      expect(Format.date(DateTime(2022,8,4)), '4 Aug 2022');
    });
  });

  group('day of week -GB local', (){
    setUp(()async{
      Intl.defaultLocale = 'en-GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });
    test('2022-2-14 => monday', (){
      expect(Format.dayOfWeek(DateTime(2022,2,14)), 'Mon');
    });
  });

  group('currency - en_US ', (){
    setUp((){
      Intl.defaultLocale = 'en-US';
    });
        test('psotive', (){
      expect(Format.currency(1), '\$1');
    });  
    test('zero', (){
      expect(Format.currency(0), '');
    });
    test('negative', (){
      expect(Format.currency(-1), '-\$1');
    }); 
  });
  
}