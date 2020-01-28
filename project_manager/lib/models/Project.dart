class Project {
  final String projID;
  final double budget;
  final double spentBudget;
  final String projname;
  final String location;
  final double completion;
  final double adhesiveTotalLitre;
  final double adhesiveUsedLitre;
  final double adhesivePrice;
  final double abrasiveTotalWeight;
  final double abrasiveUsedWeight;
  final double abrasivePrice;
  final double paintTotalLitre;
  final double paintUsedLitre;
  final double paintPrice;
  final double totalSurfaceAreaB;
  final double blastedArea;
  final double totalSurfaceAreaP;
  final double paintedArea;
  final List userAssigned;
  final double blastPot;
  final Map blastPotList;
  var date;

  Project({
    this.projID,
    this.budget,
    this.spentBudget,
    this.projname,
    this.location,
    this.completion,
    this.adhesiveTotalLitre,
    this.adhesiveUsedLitre,
    this.adhesivePrice,
    this.abrasiveTotalWeight,
    this.abrasiveUsedWeight,
    this.abrasivePrice,
    this.paintTotalLitre,
    this.paintUsedLitre,
    this.paintPrice,
    this.totalSurfaceAreaB,
    this.blastedArea,
    this.totalSurfaceAreaP,
    this.paintedArea,
    this.userAssigned,
    this.blastPot,
    this.blastPotList,
    this.date,
  });
}

class BlastPot {
  final int num;
  final double usedAbrasive;
  final double usedAdhesive;
  final double usedPaint;

  BlastPot({
    this.num,
    this.usedAbrasive,
    this.usedAdhesive,
    this.usedPaint,
  });
}
