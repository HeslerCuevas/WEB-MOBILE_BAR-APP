import os

path = r'data\services\promotions_eval_service.dart'
with open(path, 'r', encoding='utf-8') as f:
    text = f.read()

old_label = '''  String promoLabel(PromocionesCacheData promo) {
    if (promo.tipoDescuento == 'PORCENTAJE') {
      return '-%';
    } else {
      return '-';
    }
  }'''

new_label = '''  String promoLabel(PromocionesCacheData promo) {
    if (promo.tipoDescuento == 'PORCENTAJE') {
      return '-%';
    } else {
      return '-\{promo.valor.toStringAsFixed(0)}';
    }
  }'''

if old_label in text:
    text = text.replace(old_label, new_label)
else:
    print('COULD NOT FIND PROMO LABEL')

with open(path, 'w', encoding='utf-8') as f:
    f.write(text)
