#!/bin/bash
# build-tp.sh : construit l'historique LOCAL du TP GestionVehicule (étapes 1 à 14)
# Usage : bash build-tp.sh        (depuis n'importe où ; crée ~/GestionVehicule)
set -e

JUNIT=/usr/share/java/junit-platform-console-standalone.jar
DIR="$HOME/GestionVehicule"
P=src/main/java/fr/nanterre/vehicules
T=src/test/java/fr/nanterre/vehicules

[ -f "$JUNIT" ] || { echo "JUnit absent : sudo apt install -y junit5 openjdk-17-jdk"; exit 1; }
[ -n "$(git config --global user.name)" ] && [ -n "$(git config --global user.email)" ] \
  || { echo "Configurez d'abord git config --global user.name / user.email"; exit 1; }
[ -e "$DIR" ] && { echo "$DIR existe déjà : supprimez-le ou renommez-le."; exit 1; }

mkdir -p "$DIR" && cd "$DIR"
git init -q -b main
mkdir -p $P $T

ci() { git add -A && git commit -q -m "$1"; }
step() { echo ">>> $1"; }

# ---------- Générateurs de fichiers ----------

write_vehicule() { cat > $P/Vehicule.java <<'EOF'
package fr.nanterre.vehicules;

public class Vehicule {
    private final String immatriculation;
    private String marque;
    private String modele;
    private int annee;

    public Vehicule(String immatriculation, String marque, String modele, int annee) {
        this.immatriculation = immatriculation;
        this.marque = marque;
        this.modele = modele;
        this.annee = annee;
    }

    public String getImmatriculation() { return immatriculation; }
    public String getMarque() { return marque; }
    public String getModele() { return modele; }
    public int getAnnee() { return annee; }

    public void setMarque(String marque) { this.marque = marque; }
    public void setModele(String modele) { this.modele = modele; }
    public void setAnnee(int annee) { this.annee = annee; }

    @Override
    public String toString() {
        return immatriculation + " : " + marque + " " + modele + " (" + annee + ")";
    }
}
EOF
}

write_gestion_v1() { cat > $P/GestionVehicule.java <<'EOF'
package fr.nanterre.vehicules;

import java.util.ArrayList;
import java.util.List;

public class GestionVehicule {
    static final String VERSION = "0.1.0";

    public static void main(String[] args) {
        System.out.println("Gestion de véhicules - v" + VERSION);
        List<Vehicule> parc = new ArrayList<>();
        parc.add(new Vehicule("AB-123-CD", "Renault", "Clio", 2021));
        afficher(parc);
    }

    static void afficher(List<Vehicule> parc) {
        System.out.println(parc.size() + " véhicules dans le parc :");
        for (Vehicule v : parc) {
            System.out.println("  " + v);
        }
    }
}
EOF
}

# Variables : V (version), TITLE, MOD, SUP, C3 (0/1), PLUR (texte)
V=0.2.0; TITLE="Gestion de véhicules - v"; MOD=0; SUP=0; C3=0
PLUR=" véhicules dans le parc :"
write_gestion() {
  local L_C3="" L_MOD="" L_SUP=""
  [ "$C3" = 1 ]  && L_C3='        AjoutVehicule.ajouter(parc, new Vehicule("MN-012-OP", "Citroën", "C3", 2020));'
  [ "$MOD" = 1 ] && L_MOD='        System.out.println("Modification EF-456-GH : "
                + ModifierVehicule.modifier(parc, "EF-456-GH", "Peugeot", "308", 2022));'
  [ "$SUP" = 1 ] && L_SUP='        System.out.println("Suppression IJ-789-KL : "
                + SupprimerVehicule.supprimer(parc, "IJ-789-KL"));'
  cat > $P/GestionVehicule.java <<EOF
package fr.nanterre.vehicules;

import java.util.ArrayList;
import java.util.List;

public class GestionVehicule {
    static final String VERSION = "$V";

    public static void main(String[] args) {
        System.out.println("$TITLE" + VERSION);
        List<Vehicule> parc = new ArrayList<>();
        AjoutVehicule.ajouter(parc, new Vehicule("AB-123-CD", "Renault", "Clio", 2021));
        AjoutVehicule.ajouter(parc, new Vehicule("EF-456-GH", "Peugeot", "208", 2019));
        AjoutVehicule.ajouter(parc, new Vehicule("IJ-789-KL", "Tesla", "Model 3", 2023));
$L_C3
        System.out.println("Ajout d'un doublon : "
                + AjoutVehicule.ajouter(parc, new Vehicule("AB-123-CD", "Dacia", "Sandero", 2020)));
$L_MOD
$L_SUP
        afficher(parc);
    }

    static void afficher(List<Vehicule> parc) {
        System.out.println(parc.size() + "$PLUR");
        for (Vehicule v : parc) {
            System.out.println("  " + v);
        }
    }
}
EOF
  # supprime les lignes vides laissées par les blocs optionnels absents
  sed -i '/^$/N;/^\n$/D' $P/GestionVehicule.java
}

write_ajout() { # $1 = equals | equalsIgnoreCase
cat > $P/AjoutVehicule.java <<EOF
package fr.nanterre.vehicules;

import java.util.List;

public class AjoutVehicule {
    // Ajoute le véhicule s'il n'est pas déjà dans le parc ;
    // renvoie true si l'ajout a eu lieu, false si c'est un doublon
    public static boolean ajouter(List<Vehicule> parc, Vehicule nouveau) {
        for (Vehicule v : parc) {
            if (v.getImmatriculation().$1(nouveau.getImmatriculation())) {
                return false;
            }
        }
        parc.add(nouveau);
        return true;
    }
}
EOF
}

write_modifier() { cat > $P/ModifierVehicule.java <<'EOF'
package fr.nanterre.vehicules;

import java.util.List;

public class ModifierVehicule {
    // Modifie la marque, le modèle et l'année du véhicule ;
    // renvoie true si le véhicule existe, false sinon
    public static boolean modifier(List<Vehicule> parc, String immatriculation,
                                   String marque, String modele, int annee) {
        for (Vehicule v : parc) {
            if (v.getImmatriculation().equals(immatriculation)) {
                v.setMarque(marque);
                v.setModele(modele);
                v.setAnnee(annee);
                return true;
            }
        }
        return false;
    }
}
EOF
}

write_supprimer() { cat > $P/SupprimerVehicule.java <<'EOF'
package fr.nanterre.vehicules;

import java.util.List;

public class SupprimerVehicule {
    // Supprime le véhicule ; renvoie true s'il existait
    public static boolean supprimer(List<Vehicule> parc, String immatriculation) {
        return parc.removeIf(v -> v.getImmatriculation().equals(immatriculation));
    }
}
EOF
}

write_rechercher() { cat > $P/RechercherVehicule.java <<'EOF'
package fr.nanterre.vehicules;

import java.util.List;

public class RechercherVehicule {
    // Renvoie le véhicule trouvé, ou null s'il n'existe pas
    public static Vehicule rechercher(List<Vehicule> parc, String immatriculation) {
        for (Vehicule v : parc) {
            if (v.getImmatriculation().equals(immatriculation)) {
                return v;
            }
        }
        return null;
    }
}
EOF
}

write_tests_ajout() { # $1 = 1 pour inclure le test des minuscules
cat > $T/AjoutVehiculeTest.java <<'EOF'
package fr.nanterre.vehicules;

import static org.junit.jupiter.api.Assertions.*;
import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;

class AjoutVehiculeTest {
    @Test
    void ajoutAugmenteLeParc() {
        List<Vehicule> parc = new ArrayList<>();
        assertTrue(AjoutVehicule.ajouter(parc, new Vehicule("AB-123-CD", "Renault", "Clio", 2021)));
        assertEquals(1, parc.size());
    }

    @Test
    void doublonRefuse() {
        List<Vehicule> parc = new ArrayList<>();
        AjoutVehicule.ajouter(parc, new Vehicule("AB-123-CD", "Renault", "Clio", 2021));
        assertFalse(AjoutVehicule.ajouter(parc, new Vehicule("AB-123-CD", "Dacia", "Sandero", 2020)));
        assertEquals(1, parc.size());
    }
EOF
if [ "$1" = 1 ]; then cat >> $T/AjoutVehiculeTest.java <<'EOF'

    @Test
    void doublonEnMinusculesRefuse() {
        List<Vehicule> parc = new ArrayList<>();
        AjoutVehicule.ajouter(parc, new Vehicule("AB-123-CD", "Renault", "Clio", 2021));
        assertFalse(AjoutVehicule.ajouter(parc, new Vehicule("ab-123-cd", "Renault", "Clio", 2021)));
    }
EOF
fi
echo "}" >> $T/AjoutVehiculeTest.java
}

write_tests_autres() {
cat > $T/ModifierVehiculeTest.java <<'EOF'
package fr.nanterre.vehicules;

import static org.junit.jupiter.api.Assertions.*;
import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;

class ModifierVehiculeTest {
    @Test
    void modifierChangeLeModele() {
        List<Vehicule> parc = new ArrayList<>();
        parc.add(new Vehicule("EF-456-GH", "Peugeot", "208", 2019));
        assertTrue(ModifierVehicule.modifier(parc, "EF-456-GH", "Peugeot", "308", 2022));
        assertEquals("308", parc.get(0).getModele());
    }

    @Test
    void modifierVehiculeAbsentRenvoieFalse() {
        List<Vehicule> parc = new ArrayList<>();
        assertFalse(ModifierVehicule.modifier(parc, "ZZ-999-ZZ", "Fiat", "500", 2020));
    }
}
EOF
}

write_test_supprimer() { cat > $T/SupprimerVehiculeTest.java <<'EOF'
package fr.nanterre.vehicules;

import static org.junit.jupiter.api.Assertions.*;
import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;

class SupprimerVehiculeTest {
    @Test
    void supprimerRetireLeVehicule() {
        List<Vehicule> parc = new ArrayList<>();
        parc.add(new Vehicule("IJ-789-KL", "Tesla", "Model 3", 2023));
        assertTrue(SupprimerVehicule.supprimer(parc, "IJ-789-KL"));
        assertEquals(0, parc.size());
    }
}
EOF
}

write_test_rechercher() { cat > $T/RechercherVehiculeTest.java <<'EOF'
package fr.nanterre.vehicules;

import static org.junit.jupiter.api.Assertions.*;
import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;

class RechercherVehiculeTest {
    // cas de base
    @Test
    void rechercherTrouveLeVehicule() {
        List<Vehicule> parc = new ArrayList<>();
        parc.add(new Vehicule("AB-123-CD", "Renault", "Clio", 2021));
        assertEquals("Clio", RechercherVehicule.rechercher(parc, "AB-123-CD").getModele());
    }
}
EOF
}

# ---------- Étape 1 : v0.1.0 ----------
step "Étape 1 : v0.1.0"
printf '# Classes compilées par javac\nout/\n# Fichiers des éditeurs\n.idea/\n.vscode/\n' > .gitignore
echo "# GestionVehicule" > README.md
write_vehicule
write_gestion_v1
ci "chore: créer le projet GestionVehicule"
git tag -a v0.1.0 -m "Projet initial"

# ---------- Étape 2 : v0.2.0 ----------
step "Étape 2 : v0.2.0"
write_ajout equals
V=0.2.0; write_gestion
ci "feat: ajouter un véhicule (AjoutVehicule)"
git tag -a v0.2.0 -m "Ajout d'un véhicule"

# ---------- Étape 3 : renommer, supprimer, ne plus suivre ----------
step "Étape 3 : notes et config.env"
echo "brouillon" > notes.txt
ci "docs: ajouter des notes"
git mv notes.txt NOTES.md
git commit -q -m "docs: renommer les notes"
git rm -q NOTES.md
git commit -q -m "docs: supprimer les notes"
echo "MOT_DE_PASSE=1234" > config.env
ci "chore: ajouter la configuration"
git rm -q --cached config.env
echo "*.env" >> .gitignore
git add .gitignore
git commit -q -m "chore: ne plus suivre config.env"

# ---------- Étape 4 : v0.3.0 ----------
step "Étape 4 : v0.3.0"
write_modifier
V=0.3.0; MOD=1; write_gestion
ci "feat: modifier un véhicule (ModifierVehicule)"
git tag -a v0.3.0 -m "Modification d'un véhicule"

# ---------- Étape 5 : v0.4.0 ----------
step "Étape 5 : v0.4.0 (tests)"
cat > test.sh <<'EOF'
#!/bin/sh
# Compile le code et les tests, puis lance les tests JUnit
JUNIT=/usr/share/java/junit-platform-console-standalone.jar
rm -rf out
javac -d out -cp "$JUNIT" $(find src -name "*.java") || exit 1
java -jar "$JUNIT" execute --disable-banner --disable-ansi-colors \
     -cp out --select-package fr.nanterre.vehicules
EOF
chmod +x test.sh
write_tests_ajout 0
write_tests_autres
V=0.4.0; write_gestion
./test.sh > /dev/null || { echo "Les tests échouent à l'étape 5"; exit 1; }
ci "test: ajouter les tests de AjoutVehicule et ModifierVehicule"
git tag -a v0.4.0 -m "Tests automatisés"

# ---------- Étape 6 : revert ----------
step "Étape 6 : commit puis revert"
sed -i 's/"Gestion de véhicules - v"/"Gestion de véhicules - VERSION CASSÉE - v"/' $P/GestionVehicule.java
git commit -q -am "feat: changer le titre"
git revert --no-edit HEAD > /dev/null

# ---------- Étape 7 : v0.5.0 ----------
step "Étape 7 : v0.5.0 (branche + --no-ff)"
git switch -q -c feature/suppression
write_supprimer
write_test_supprimer
V=0.4.0; SUP=1; write_gestion
./test.sh > /dev/null || { echo "Les tests échouent à l'étape 7"; exit 1; }
ci "feat: supprimer un véhicule (SupprimerVehicule)"
git switch -q main
git merge -q --no-ff feature/suppression -m "Merge branch 'feature/suppression'"
V=0.5.0; write_gestion
git commit -q -am "chore: passer en version 0.5.0"
git tag -a v0.5.0 -m "Suppression d'un véhicule"
git branch -q -d feature/suppression

# ---------- Étape 8 : conflit ----------
step "Étape 8 : conflit"
git switch -q -c feature/titre
TITLE="Gestion de véhicules - Parc de Nanterre - v"; write_gestion
git commit -q -am "feat: afficher le nom du parc"
git switch -q main
TITLE="Gestion de véhicules (stable) - v"; write_gestion
git commit -q -am "fix: simplifier le titre"
git merge feature/titre > /dev/null 2>&1 || echo "    (conflit provoqué, résolution automatique)"
TITLE="Gestion de véhicules - Parc de Nanterre (stable) - v"; write_gestion
! grep -rn "<<<<<<<\|>>>>>>>" src/ || { echo "Marqueurs restants"; exit 1; }
git add $P/GestionVehicule.java
git commit -q --no-edit
git branch -q -d feature/titre

# ---------- Étape 9 : README (urgence pendant le stash) ----------
step "Étape 9 : README"
echo "Programme Java en console qui gère un parc de véhicules." >> README.md
git commit -q -am "docs: décrire le projet dans le README"

# ---------- Étape 10 : travail à deux (simulé) ----------
step "Étape 10 : binôme simulé"
git switch -q -c tmp-binome
echo "Auteurs : vous et votre binôme" >> README.md
git commit -q -am "docs: ajouter les auteurs"
git switch -q main
C3=1; write_gestion
git commit -q -am "feat: ajouter un quatrième véhicule de démonstration"
git merge -q --no-edit tmp-binome > /dev/null
git branch -q -D tmp-binome
./test.sh > /dev/null || { echo "Les tests échouent à l'étape 10"; exit 1; }

# ---------- Étape 11 : v0.5.1 ----------
step "Étape 11 : v0.5.1"
git switch -q -c fix/doublon-casse
write_ajout equalsIgnoreCase
write_tests_ajout 1
V=0.5.1; write_gestion
./test.sh > /dev/null || { echo "Les tests échouent à l'étape 11"; exit 1; }
ci "fix: refuser un doublon écrit en minuscules"
git switch -q main
git merge -q --no-ff fix/doublon-casse -m "Merge branch 'fix/doublon-casse'"
git tag -a v0.5.1 -m "Doublon insensible à la casse"
git branch -q -d fix/doublon-casse

# ---------- Étape 12 : hooks ----------
step "Étape 12 : hooks"
git switch -q -c chore/hooks
mkdir -p .githooks
cat > .githooks/commit-msg <<'EOF'
#!/bin/sh
# Refuse les messages qui ne suivent pas « type: description »
if ! grep -qE '^((feat|fix|test|docs|chore|refactor): .+|Merge .+|Revert .+)' "$1"; then
  echo "Message refusé : utilisez « type: description » (feat, fix, test, docs, chore, refactor)."
  exit 1
fi
EOF
cat > .githooks/pre-commit <<'EOF'
#!/bin/sh
# Lance les tests avant chaque commit ; un test rouge bloque le commit
echo "pre-commit : lancement des tests…"
if ! ./test.sh > /dev/null; then
  echo "Tests en échec : commit refusé."
  exit 1
fi
EOF
chmod +x .githooks/commit-msg .githooks/pre-commit
ci "chore: partager les hooks du projet"
printf '\n## Après le clone\n\n    git config core.hooksPath .githooks\n' >> README.md
ci "docs: expliquer l'activation des hooks"
git switch -q main
git merge -q --no-ff chore/hooks -m "Merge branch 'chore/hooks'"
git branch -q -d chore/hooks

# ---------- Étape 13 : v0.6.0 ----------
step "Étape 13 : v0.6.0"
echo "Recherche par immatriculation (en cours)" >> README.md
git commit -q -am "docs: annoncer la recherche"
git switch -q -c feature/recherche
write_rechercher
write_test_rechercher
ci "feat: rechercher un véhicule (RechercherVehicule)"
printf '\n## Compiler\n\n    javac -d out $(find src/main -name "*.java")\n' >> README.md
ci "docs: expliquer la compilation"
V=0.6.0; write_gestion
./test.sh > /dev/null || { echo "Les tests échouent à l'étape 13"; exit 1; }
ci "chore: passer en version 0.6.0"
git switch -q main
git merge -q --no-ff feature/recherche -m "Merge branch 'feature/recherche'"
git tag -a v0.6.0 -m "Recherche d'un véhicule"
git branch -q -d feature/recherche

# ---------- Étape 14 : GitFlow ----------
step "Étape 14 : GitFlow v0.7.0 et v0.7.1"
git switch -q -c develop
git switch -q -c feature/compter-marque develop
sed -i '$ d' $P/RechercherVehicule.java
cat >> $P/RechercherVehicule.java <<'EOF'

    // Compte les véhicules d'une marque
    public static long compterParMarque(List<Vehicule> parc, String marque) {
        return parc.stream().filter(v -> v.getMarque().equals(marque)).count();
    }
}
EOF
./test.sh > /dev/null || { echo "Les tests échouent à l'étape 14"; exit 1; }
git commit -q -am "feat: compter les véhicules d'une marque"
git switch -q develop
git merge -q --no-ff feature/compter-marque -m "Merge branch 'feature/compter-marque' into develop"
git branch -q -d feature/compter-marque
V=0.7.0; write_gestion
git commit -q -am "chore: passer en version 0.7.0"
git switch -q main
git merge -q --no-ff develop -m "release: v0.7.0"
git tag -a v0.7.0 -m "Compter par marque"

git switch -q -c hotfix/0.7.1 main
PLUR=" véhicule(s) dans le parc :"; V=0.7.1; write_gestion
./test.sh > /dev/null || { echo "Les tests échouent au hotfix"; exit 1; }
git commit -q -am "fix: corriger le pluriel du nombre de véhicules"
git switch -q main
git merge -q --no-ff hotfix/0.7.1 -m "Merge branch 'hotfix/0.7.1'"
git tag -a v0.7.1 -m "Correctif du pluriel"
git switch -q develop
git merge -q --no-ff hotfix/0.7.1 -m "Merge branch 'hotfix/0.7.1' into develop"
git branch -q -d hotfix/0.7.1
git switch -q main

# ---------- Activer les hooks maintenant que tout est commité ----------
git config core.hooksPath .githooks

# ---------- Vérifications ----------
echo
echo "=== Tags et VERSION ==="
for t in $(git tag); do
  echo "$t -> $(git show $t:$P/GestionVehicule.java | grep 'VERSION =' | tr -s ' ')"
done
echo
echo "=== Tests ==="
./test.sh | tail -4
echo
echo "=== Historique (extrait) ==="
git log --oneline --graph --decorate --all -25
echo
cat <<EOF
Terminé. Dépôt local : $DIR

Pour publier (après avoir créé le dépôt VIDE sur GitHub) :
  git remote add origin git@github.com:<pseudo>/GestionVehicule.git
  git push -u origin main
  git push origin develop
  git push --tags
EOF
