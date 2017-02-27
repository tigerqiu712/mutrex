package regex.mutrex.parallel;

import java.util.Iterator;
import java.util.Set;

import regex.operators.RegexMutator.MutatedRegExp;

public class MutantsManagerNoLimit extends MutantsManager {

	public MutantsManagerNoLimit(Iterator<MutatedRegExp> itMutants) {
		super(itMutants);
	}

	@Override
	public synchronized boolean areThereUncoveredMutants() {
		if (noUncoveredMutants)
			return false;
		if (itMutants.hasNext()) {
			return true;
		} else {
			for (Mutant m : mutants) {
				if (!m.isEquivalent() && !m.isCovered) {
					return true;
				}
			}
		}
		noUncoveredMutants = true;
		return false;
	}

	@Override
	public synchronized Mutant getNotCoveredByCurrentDAs(Set<DistinguishAutomatonTh> datS) {
		if (!noUncoveredMutants) {
			/*if (mutants.size() == 0) {
				if (itMutants.hasNext()) {
					Mutant mutant = new Mutant(itMutants.next());
					mutants.add(mutant);
					mutant.lock();
					return mutant;
				}
			} else {
				// Collections.shuffle(mutants);
				for (Mutant mutant : mutants) {
					if (!mutant.isCovered && !mutant.isEquivalent() && mutant.visited.containsAll(datS)
							&& !mutant.isLocked()) {
						mutant.lock();
						return mutant;
					}
				}
			}*/
			for (Mutant mutant : mutants) {
				if (!mutant.isCovered && !mutant.isEquivalent() && mutant.visited.containsAll(datS)
						&& !mutant.isLocked()) {
					mutant.lock();
					return mutant;
				}
			}
			if (itMutants.hasNext()) {
				Mutant mutant = new Mutant(itMutants.next());
				mutants.add(mutant);
				mutant.lock();
				return mutant;
			}
		}
		return null;
	}

	@Override
	public synchronized Mutant getMutant(DistinguishAutomatonTh s) {
		boolean stopDA = true;
		if (!noUncoveredMutants) {
			if (itMutants.hasNext()) {
				Mutant mutant = new Mutant(itMutants.next());
				mutant.setVisitedDA(s);
				mutant.lock();
				mutants.add(mutant);
				return mutant;
			} else {
				// Collections.shuffle(mutants);
				for (Mutant mutant : mutants) {
					if (!mutant.isCovered && !mutant.isEquivalent() && !mutant.hasVisitedDA(s)) {
						stopDA = false;
						if (!mutant.isLocked()) {
							mutant.setVisitedDA(s);
							mutant.lock();
							return mutant;
						}
					}
				}
			}
		}
		if (stopDA) {
			s.stopThread();
		}
		return null;
	}

	@Override
	public void mutantConsidered() {}
}