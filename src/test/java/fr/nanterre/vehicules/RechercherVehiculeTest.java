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
