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
