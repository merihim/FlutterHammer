import 'package:dice_roller/CombatProperties.dart';
import 'CommonUtil.dart';

class CombatCalculator {
  static int calculateDamage(CombatProperties combatProperties) {
    int hits = calculateRoll(combatProperties.attacks, combatProperties.hit,
        combatProperties.rerollHitOnes, combatProperties.rerollHits);

    int wounds = calculateRoll(hits, combatProperties.wound,
        combatProperties.rerollWoundOnes, combatProperties.rerollWounds);

    int saveNeed = combatProperties.save + combatProperties.rend;
    int saves = calculateRoll(wounds, saveNeed, combatProperties.rerollSaveOnes,
        combatProperties.rerollSaves);

    int damageRolls = wounds - saves;
    int totalDamage = 0;
    for (var i = 0; i < damageRolls; i++) {
      int damageFromSingleAttack;
      if (combatProperties.damage.contains("d")) {
        if (combatProperties.damage.contains("d3")) {
          damageFromSingleAttack = CommonUtil.rollD3();
        }
        if (combatProperties.damage.contains("d6")) {
          damageFromSingleAttack = CommonUtil.rollD6();
        }
      } else {
        damageFromSingleAttack = int.parse(combatProperties.damage);
      }

      totalDamage += damageFromSingleAttack;
    }
    return totalDamage;
  }

  static int calculateRoll(
      int iterations, int threshold, bool rerollingOnes, bool rerollAll) {
    int total = 0;
    for (var i = 0; i < iterations; i++) {
      int roll = CommonUtil.rollD6();
      if (roll >= threshold) {
        total++;
      } else if (rerollingOnes && !rerollAll && roll == 1) {
        roll = CommonUtil.rollD6();
        if (roll >= threshold) {
          total++;
        }
      } else if (!rerollingOnes && rerollAll) {
        roll = CommonUtil.rollD6();
        if (total >= threshold) {
          total++;
        }
      }
    }
    return total;
  }
}
