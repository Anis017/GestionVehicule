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

    @Test
    void doublonEnMinusculesRefuse() {
        List<Vehicule> parc = new ArrayList<>();
        AjoutVehicule.ajouter(parc, new Vehicule("AB-123-CD", "Renault", "Clio", 2021));
        assertFalse(AjoutVehicule.ajouter(parc, new Vehicule("ab-123-cd", "Renault", "Clio", 2021)));
    }
}
