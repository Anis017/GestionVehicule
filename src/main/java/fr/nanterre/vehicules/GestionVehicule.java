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
