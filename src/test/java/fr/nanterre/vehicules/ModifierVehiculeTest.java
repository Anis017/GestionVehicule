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
