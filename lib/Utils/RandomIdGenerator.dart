import 'dart:math';

String generateId([int length = 8]) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rand = Random();
  return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
      .join();
}
