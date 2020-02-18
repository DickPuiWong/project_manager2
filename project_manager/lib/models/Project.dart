// Name : Project.dart
// Purpose : all the variables that is needed in Project class
// Function : This file contains all the declared and initialised variables for Project, BlastPot, BudgetType, ProgressType  classes

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
  final List projectSupervisor;
  final List userAssigned;
  final double blastPot;
  final Map blastPotList;
  final Map budgetList;
  final Map progressesTracked;
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
    this.projectSupervisor,
    this.blastPot,
    this.blastPotList,
    this.budgetList,
    this.progressesTracked,
    this.date,
  });
}

////////////////////////////////////////////////////////////////////////////////

class BlastPot {
  final int num;
  final double usedAbrasive;
  final double usedAdhesive;
  final double usedHours;

  BlastPot({
    this.num,
    this.usedAbrasive,
    this.usedAdhesive,
    this.usedHours,
  });
}

////////////////////////////////////////////////////////////////////////////////

class BudgetType {
  final String name;
  final double spent;
  final double estimate;

  BudgetType({
    this.name,
    this.spent,
    this.estimate,
  });
}

////////////////////////////////////////////////////////////////////////////////

class ProgressType {
  final String name;
  final double done;
  final double total;

  ProgressType({
    this.name,
    this.done,
    this.total,
  });
}
