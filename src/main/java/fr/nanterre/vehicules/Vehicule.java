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
